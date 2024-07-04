
#Область СлужебныйПрограммныйИнтерфейс

#Область ПроцедурыИФункцииУстановкиСтатусовДляМассиваДокументов

// Устанавливает статус для списка документов
//
// Параметры:
//  МассивДокументов		 - Массив	 - Массив документов
//  НовыйСтатус				 - Строка	 - Имя нового статуса для документов
//  ДополнительныеПараметры	 - Структура - Структура дополнительных параметров
// 
// Возвращаемое значение:
//  Число - Количество документов у которых был изменен статус
//  ВАЖНО. При использования процедуры для каждого типа документа из массива должны быть объявлены функции:
//  В модуле менеджера документа:
//  Функция СформироватьЗапросПроверкиПриСменеСтатуса(МассивДокументов, НовыйСтатус, ДополнительныеПараметры) Экспорт
//  Функция ПроверкаПередСменойСтатуса(ВыборкаПроверки, НовыйСтатус, ДополнительныеПараметры) Экспорт
//  В модуле объекта документа:
//  Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
//
Функция УстановитьСтатусДокументов(Знач МассивДокументов, Знач НовыйСтатус, Знач ДополнительныеПараметры=Неопределено) Экспорт
	
	// Получение шаблонов сообщений стандартных ошибок
	ШаблонОшибкиСтатусСовпадает   = НСтр("en='Document %Документ% already has the status ""%Статус%""';ru='Документу %Документ% уже присвоен статус ""%Статус%""'");
	ШаблонОшибкиНеПроведен        = НСтр("en='Document %Документ% was not posted. You cannot change the status';ru='Документ %Документ% не проведен. Невозможно изменить статус'");
	ШаблонОшибкиПомеченНаУдаление = НСтр("en='Document %Документ% are flagged for deletion. You cannot change the status';ru='Документ %Документ% помечен на удаление. Невозможно изменить статус'");
	ШаблонОшибкиЗаблокировать     = НСтр("en='Failed to lock %Документ%. %ОписаниеОшибки%';ru='Не удалось заблокировать %Документ%. %ОписаниеОшибки%'");
	ШаблонОшибкиЗаписать          = НСтр("en='Failed to write %Документ%. %ОписаниеОшибки%';ru='Не удалось записать %Документ%. %ОписаниеОшибки%'");
	
	// Получение соответствие типов документов из массива документов разных типов
	СоответствиеТипов = ОбщегоНазначенияУТ.РазложитьМассивСсылокПоТипам(МассивДокументов);
	
	КоличествоОбработанных = 0;
	Для Каждого СоставДокументов Из СоответствиеТипов Цикл
		
		// Получение менеджера документов данного типа
		МенеджерДокументов = Документы[Метаданные.НайтиПоТипу(СоставДокументов.Ключ).Имя];
		
		// Получение массива ссылок документов данного типа
		МассивСсылок = СоставДокументов.Значение;
		
		// Формирование запроса
		Запрос = МенеджерДокументов.СформироватьЗапросПроверкиПриСменеСтатуса(МассивСсылок, НовыйСтатус, ДополнительныеПараметры);
		УстановитьПривилегированныйРежим(Истина);
		Результат = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		Если Результат.Пустой() Тогда
			Возврат 0;
		КонецЕсли;
		
		// Цикл обхода выборки
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			// Универсальные проверки
			Если Выборка.ПометкаУдаления Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрЗаменить(ШаблонОшибкиПомеченНаУдаление, "%Документ%", Выборка.Представление), Выборка.Ссылка);
				Продолжить;
			КонецЕсли;

			Если Не Выборка.Проведен Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрЗаменить(ШаблонОшибкиНеПроведен, "%Документ%", Выборка.Представление), Выборка.Ссылка);
				Продолжить;
			КонецЕсли;

			Если Выборка.СтатусСовпадает Тогда

				ТекстОшибки = СтрЗаменить(ШаблонОшибкиСтатусСовпадает, "%Документ%", Выборка.Представление);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", Выборка.ПредставлениеНовогоСтатуса);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
				Продолжить;

			КонецЕсли;
			
			// Проверки уникальные для каждого из типов документов
			Если Не МенеджерДокументов.ПроверкаПередСменойСтатуса(Выборка, НовыйСтатус, ДополнительныеПараметры) Тогда
				Продолжить;
			КонецЕсли;
			
			// Захват объекта для редактирования
			Попытка
				ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			Исключение
				ТекстОшибки = СтрЗаменить(ШаблонОшибкиЗаблокировать, "%Документ%", Выборка.Представление);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
				Продолжить;
			КонецПопытки;
			
			// Получение объекта документа
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			
			// Установка статуса документа
			Если Не Объект.УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Тогда
				Продолжить;
			КонецЕсли;
			
			// Запись документа
			Попытка
				Объект.Записать(?(Выборка.ЗаписьПроведением, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
				КоличествоОбработанных = КоличествоОбработанных + 1;
			Исключение
				ТекстОшибки = СтрЗаменить(ШаблонОшибкиЗаписать, "%Документ%", Выборка.Представление);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			КонецПопытки
			
		КонецЦикла; // выборки документов данного типа
		
	КонецЦикла; // обхода соответствия типов
	
	Возврат КоличествоОбработанных;
	
КонецФункции // УстановитьСтатусДокументов()

#КонецОбласти

#Область ЗначенияРеквизитовОбъекта

// см. ОбщегоНазначения.ЗначенияРеквизитовОбъекта()
//
// Параметры:
//  Ссылка		 - 	 - 
//  Реквизиты	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция ЗначенияРеквизитовОбъекта(Ссылка, Реквизиты) Экспорт
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, Реквизиты);
	
КонецФункции

// см. ОбщегоНазначения.ЗначениеРеквизитаОбъекта()
//
// Параметры:
//  Ссылка		 - 	 - 
//  ИмяРеквизита - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	
КонецФункции

#КонецОбласти

#КонецОбласти