
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Автотест = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Автотест Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновитьДанныеРеглЗаданий();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьРегламентноеЗаданиеВручнуюИнформацияоТС(Команда)
	ВыполнитьРегламентноеЗаданиеВручную(ИнформацияоТСпоДаннымШтрафовНЕТ, "Информацияо о ТС по данным Штрафов.НЕТ");
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРегламентноеЗаданиеЗагрузкаГазпромнефть(Команда)
	ВыполнитьРегламентноеЗаданиеВручную(ЗагрузкаДанныхИзШтрафовНЕТ, "Загрузка данных из Штрафов.НЕТ");
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьДанныеРеглЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРеглЗаданиеЗагрузкаДанныхШтрафовНЕТ(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Идентификатор", ЗагрузкаДанныхИзШтрафовНЕТ);
	ПараметрыФормы.Вставить("Действие",      "Изменить");
	
	ОткрытьФорму("Обработка.РегламентныеИФоновыеЗадания.Форма.РегламентноеЗадание", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРеглЗаданиеИнформацияТСПоДаннымШтрафовНЕТ(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Идентификатор", ИнформацияоТСпоДаннымШтрафовНЕТ);
	ПараметрыФормы.Вставить("Действие",      "Изменить");
	
	ОткрытьФорму("Обработка.РегламентныеИФоновыеЗадания.Форма.РегламентноеЗадание", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьРегламентноеЗаданиеВручную(РеглЗадание, РеглЗаданиеНаименование)
	МассивСообщенийОбОшибках = Новый Массив;
	
	ПараметрыВыполнения = ВыполнитьРегламентноеЗаданиеВручнуюНаСервере(РеглЗадание);
	Если ПараметрыВыполнения.ЗапускВыполнен Тогда
		
		ПоказатьОповещениеПользователя(
		НСтр("ru='Запущена процедура регламентного задания';en='Scheduled job is launched'"), ,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("en = '%1.
                                                                      |The procedure is run in background job%2'; ru = '%1.
                                                                      |Процедура запущена в фоновом задании %2'"),
		РеглЗаданиеНаименование,
		Строка(ПараметрыВыполнения.МоментЗапуска)),
		БиблиотекаКартинок.ВыполнитьРегламентноеЗаданиеВручную);
		
		ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Добавить(
		ПараметрыВыполнения.ИдентификаторФоновогоЗадания,
		РеглЗаданиеНаименование);
		
		ПодключитьОбработчикОжидания(
		"СообщитьОбОкончанииРучногоВыполненияРегламентногоЗадания", 0.1, Истина);
	ИначеЕсли ПараметрыВыполнения.ПроцедураУжеВыполняется Тогда
		МассивСообщенийОбОшибках.Добавить(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("en = 'Procedure of scheduled job ""%1"" is
              |already executed in background job ""%2"" started %3.'; ru = 'Процедура регламентного задания ""%1""
              |  уже выполняется в фоновом задании ""%2"", начатом %3.'"),
		РеглЗаданиеНаименование,
		ПараметрыВыполнения.ПредставлениеФоновогоЗадания,
		Строка(ПараметрыВыполнения.МоментЗапуска)));
	КонецЕсли;
	
	КоличествоОшибок = МассивСообщенийОбОшибках.Количество();
	Если КоличествоОшибок > 0 Тогда
		ЗаголовокТекстаПроОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Задания выполнены с ошибками (%1 из %2)';en='Jobs are completed with errors (%1 out of %2)'"),
		Формат(КоличествоОшибок, "ЧГ="),
		Формат(1, "ЧГ="));
		
		ТекстВсехОшибок = Новый ТекстовыйДокумент;
		ТекстВсехОшибок.ДобавитьСтроку(ЗаголовокТекстаПроОшибки + ":");
		Для Каждого ТекстЭтойОшибки Из МассивСообщенийОбОшибках Цикл
			ТекстВсехОшибок.ДобавитьСтроку("");
			ТекстВсехОшибок.ДобавитьСтроку(ТекстЭтойОшибки);
		КонецЦикла;
		
		Если КоличествоОшибок > 5 Тогда
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(1, НСтр("ru='Показать ошибки';en='Show errors'"));
			Кнопки.Добавить(КодВозвратаДиалога.Отмена);
			
			ПоказатьВопрос(
			Новый ОписаниеОповещения(
			"ВыполнитьРегламентноеЗаданиеВручнуюЗавершение", ЭтотОбъект, ТекстВсехОшибок),
			ЗаголовокТекстаПроОшибки, Кнопки);
		Иначе
			ПоказатьПредупреждение(, СокрЛП(ТекстВсехОшибок.ПолучитьТекст()));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеРеглЗаданий()
	Попытка
		ОбновитьДанныеРеглЗаданийСервер();
	Исключение
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеРеглЗаданийСервер()
	
	ТипФоновоеЗадание		 = Тип("ФоновоеЗадание");
	ТипИнформацияОбОшибке	 = Тип("ИнформацияОбОшибке");

	РеглЗаданиеЗагрузкаДанныхОтПоставщикаПЦГазпромнефть = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.уатЗагрузкаДанныхИзШтрафовНЕТ);
	ЗагрузкаДанныхИзШтрафовНЕТ = РеглЗаданиеЗагрузкаДанныхОтПоставщикаПЦГазпромнефть.УникальныйИдентификатор;
	
	РеглЗаданиеОбновлениеЗагруженныхДанныхОтПоставщикаПЦГазпромнефть = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.уатИнформацияоТСпоДаннымШтрафовНЕТ);
	ИнформацияоТСпоДаннымШтрафовНЕТ = РеглЗаданиеОбновлениеЗагруженныхДанныхОтПоставщикаПЦГазпромнефть.УникальныйИдентификатор;

	Подсказка =  НСтр("ru='Никогда не выполнялось';en='Never execute'");
	Если РеглЗаданиеЗагрузкаДанныхОтПоставщикаПЦГазпромнефть = Неопределено Тогда
		ПредставлениеРасписания = НСтр("ru='Регламентное задание не найдено';en='Scheduled job is not found'");
		РегламентноеЗадание_Использование = Ложь;
	Иначе
		ПоследнееФоновоеЗадание = РегламентныеЗаданияСлужебный.СвойстваФоновыхЗаданий(Новый Структура("ПолучитьПоследнееФоновоеЗаданиеРегламентногоЗадания,
		|ИдентификаторРегламентногоЗадания", Истина, ЗагрузкаДанныхИзШтрафовНЕТ));
		Подсказка = ?(РеглЗаданиеЗагрузкаДанныхОтПоставщикаПЦГазпромнефть.Использование, 
				НСтр("ru='Используется';en='Used'"), НСтр("ru='Не используется';en='Not used'"));
		Если ПоследнееФоновоеЗадание.Количество() > 0 Тогда
			Подсказка = Подсказка + ", " + Строка(ПоследнееФоновоеЗадание[0].Состояние)
			+ " " + Строка(?(Значениезаполнено(ПоследнееФоновоеЗадание[0].Конец), ПоследнееФоновоеЗадание[0].Конец, ""));
		КонецЕсли;
	КонецЕсли;
	
	Если Подсказка <> Элементы.НастроитьРегламентноеЗаданиеЗагрузкаДанных_Статус.Заголовок Тогда
		Элементы.НастроитьРегламентноеЗаданиеЗагрузкаДанных_Статус.Заголовок = Подсказка;
	КонецЕсли;
	
	Если РеглЗаданиеОбновлениеЗагруженныхДанныхОтПоставщикаПЦГазпромнефть = Неопределено Тогда
		ПредставлениеРасписания = НСтр("ru='Регламентное задание не найдено';en='Scheduled job is not found'");
		РегламентноеЗадание_Использование = Ложь;
	Иначе
		ПоследнееФоновоеЗадание = РегламентныеЗаданияСлужебный.СвойстваФоновыхЗаданий(Новый Структура("ПолучитьПоследнееФоновоеЗаданиеРегламентногоЗадания,
		|ИдентификаторРегламентногоЗадания", Истина, ИнформацияоТСпоДаннымШтрафовНЕТ));
		Подсказка = ?(РеглЗаданиеОбновлениеЗагруженныхДанныхОтПоставщикаПЦГазпромнефть.Использование, 
				НСтр("ru='Используется';en='Used'"), НСтр("ru='Не используется';en='Not used'"));
		Если ПоследнееФоновоеЗадание.Количество() > 0 Тогда
			Подсказка = Подсказка + ", " + Строка(ПоследнееФоновоеЗадание[0].Состояние)
				+ " " + Строка(?(Значениезаполнено(ПоследнееФоновоеЗадание[0].Конец), ПоследнееФоновоеЗадание[0].Конец, ""));
		КонецЕсли;
	КонецЕсли;
	
	Если Подсказка <> Элементы.НастроитьРегламентноеЗаданиеИнформацияТС_Статус.Заголовок Тогда
		Элементы.НастроитьРегламентноеЗаданиеИнформацияТС_Статус.Заголовок = Подсказка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьРегламентноеЗаданиеВручнуюНаСервере(Знач ИдентификаторРегламентногоЗадания)
	
	Результат = РегламентныеЗаданияСлужебный.ВыполнитьРегламентноеЗаданиеВручную(ИдентификаторРегламентногоЗадания);
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура СообщитьОбОкончанииРучногоВыполненияРегламентногоЗадания()
	
	ОповещенияОбОкончанииВыполнения = ОповещенияОбОкончанииВыполненияРегламентныхЗаданий();
	Для каждого Оповещение Из ОповещенияОбОкончанииВыполнения Цикл
		
		ПоказатьОповещениеПользователя(
			НСтр("ru='Выполнена процедура регламентного задания';en='Scheduled job procedure is executed'"),
			,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("en = '%1. The procedure is completed in background job %2'; ru = '%1. Процедура завершена в фоновом задании %2'"),
				Оповещение.ПредставлениеРегламентногоЗадания,
				Строка(Оповещение.МоментОкончания)),
			БиблиотекаКартинок.ВыполнитьРегламентноеЗаданиеВручную);
		ОбновитьДанныеРеглЗаданий();
	КонецЦикла;
	
	Если ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Количество() > 0 Тогда
		
		ПодключитьОбработчикОжидания(
			"СообщитьОбОкончанииРучногоВыполненияРегламентногоЗадания", 2, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОповещенияОбОкончанииВыполненияРегламентныхЗаданий()
	
	ОповещенияОбОкончанииВыполнения = Новый Массив;
	
	Если ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Количество() > 0 Тогда
		Индекс = ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Количество() - 1;
		
		УстановитьПривилегированныйРежим(Истина);
		Пока Индекс >= 0 Цикл
			
			НовыйУникальныйИдентификатор = Новый УникальныйИдентификатор(
				ИдентификаторыФоновыхЗаданийПриРучномВыполнении[Индекс].Значение);
			Отбор = Новый Структура;
			Отбор.Вставить("УникальныйИдентификатор", НовыйУникальныйИдентификатор);
			
			МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
			
			Если МассивФоновыхЗаданий.Количество() = 1 Тогда
				МоментОкончания = МассивФоновыхЗаданий[0].Конец;
				
				Если ЗначениеЗаполнено(МоментОкончания) Тогда
					
					ОповещенияОбОкончанииВыполнения.Добавить(
						Новый Структура(
							"ПредставлениеРегламентногоЗадания,
							|МоментОкончания",
							ИдентификаторыФоновыхЗаданийПриРучномВыполнении[Индекс].Представление,
							МоментОкончания));
					
					ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Удалить(Индекс);
				КонецЕсли;
			Иначе
				ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Удалить(Индекс);
			КонецЕсли;
			Индекс = Индекс - 1;
		КонецЦикла;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ОповещенияОбОкончанииВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьРегламентноеЗаданиеВручнуюЗавершение(Ответ, ТекстВсехОшибок) Экспорт
	
	Если Ответ = 1 Тогда
		ТекстВсехОшибок.Показать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

