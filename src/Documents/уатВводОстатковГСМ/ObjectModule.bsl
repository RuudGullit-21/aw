
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.уатВводОстатковГСМ.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	уатПроведение.ОтразитьОстаткиГСМНаТС(ДополнительныеСвойства, Движения, Отказ);
	уатПроведение.ОтразитьПартииТЖ(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.уатВводОстатковГСМ.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		// Заголовок для сообщений об ошибках проведения.
		Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
		СтруктураПолей = Новый Структура("Организация");
		уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураПолей, Отказ, Заголовок);
		
		СтруктураПолей = Новый Структура("ТС, ГСМ, Количество");
		уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Топливо", СтруктураПолей, Отказ,
																		Заголовок);
		
		// проверка по наличию бака в ТС
		Если Не Отказ Тогда
			Для Каждого СтрокаТаблицы Из Топливо Цикл
				Если НЕ СтрокаТаблицы.ТС.Модель.НаличиеТопливногоБака Тогда
					ТекстНСТР = НСтр("en='At line №%1 tabular section ""Fuel"" specified vehicle/equipment that does not have fuel tank!';ru='В строке №%1 табличной части ""Топливо"" указано ТС/оборудование, у которого отсутствует топливный бак!'");
					ТекстНСТР = СтрШаблон(ТекстНСТР, СтрокаТаблицы.НомерСтроки);
					уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		уатОбщегоНазначения.ПроверкаЗаполненияПодразделения(Организация, Подразделение, Отказ, Заголовок);
		уатОбщегоНазначенияСервер.ПроверкаСоответствияМестонахожденияТС(ЭтотОбъект, Отказ, "Топливо", Заголовок);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	// Инициализация дополнительных свойств для проведения документа
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.уатВводОстатковГСМ.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатИнвентаризацияГСМвТС") Тогда
		СтандартнаяОбработка = Ложь;
		
		уатОбщегоНазначенияТиповые.ЗаполнитьШапкуДокумента(ЭтотОбъект, ПользователиКлиентСервер.АвторизованныйПользователь());
		
		ДокументОснование = ДанныеЗаполнения;
		Организация       = ДанныеЗаполнения.Организация;
		Подразделение     = ДанныеЗаполнения.Подразделение;
		Колонна           = ДанныеЗаполнения.Колонна;
		Ответственный     = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
						  ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнойОтветственный");
		Дата              = ДанныеЗаполнения.Дата;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДокументСсылка",          Ссылка);
		Запрос.УстановитьПараметр("ДокументОснованиеСсылка", ДанныеЗаполнения);
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатИнвентаризацияГСМвТСГСМвТС.ТС,
		|	уатИнвентаризацияГСМвТСГСМвТС.ГСМ,
		|	МАКСИМУМ(уатИнвентаризацияГСМвТСГСМвТС.Количество - уатИнвентаризацияГСМвТСГСМвТС.КоличествоУчет) КАК КоличествоОтклонениеИнвентаризации,
		|	уатИнвентаризацияГСМвТСГСМвТС.Цена,
		|	СУММА(ВЫБОР
		|			КОГДА уатВводОстатковГСМТопливо.Количество ЕСТЬ NULL 
		|				ТОГДА 0
		|			ИНАЧЕ уатВводОстатковГСМТопливо.Количество
		|		КОНЕЦ) КАК КоличествоОприходованное
		|ИЗ
		|	Документ.уатИнвентаризацияГСМвТС.ГСМвТС КАК уатИнвентаризацияГСМвТСГСМвТС
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.уатВводОстатковГСМ.Топливо КАК уатВводОстатковГСМТопливо
		|		ПО уатИнвентаризацияГСМвТСГСМвТС.ГСМ = уатВводОстатковГСМТопливо.ГСМ
		|			И уатИнвентаризацияГСМвТСГСМвТС.ТС = уатВводОстатковГСМТопливо.ТС
		|			И (уатВводОстатковГСМТопливо.Ссылка.ДокументОснование = &ДокументОснованиеСсылка)
		|			И (уатВводОстатковГСМТопливо.Ссылка.Проведен)
		|			И (уатВводОстатковГСМТопливо.Ссылка <> &ДокументСсылка)
		|ГДЕ
		|	уатИнвентаризацияГСМвТСГСМвТС.Ссылка = &ДокументОснованиеСсылка
		|	И уатИнвентаризацияГСМвТСГСМвТС.Количество - уатИнвентаризацияГСМвТСГСМвТС.КоличествоУчет > 0
		|
		|СГРУППИРОВАТЬ ПО
		|	уатИнвентаризацияГСМвТСГСМвТС.НомерСтроки,
		|	уатИнвентаризацияГСМвТСГСМвТС.ТС,
		|	уатИнвентаризацияГСМвТСГСМвТС.ГСМ,
		|	уатИнвентаризацияГСМвТСГСМвТС.Цена
		|
		|УПОРЯДОЧИТЬ ПО
		|	уатИнвентаризацияГСМвТСГСМвТС.НомерСтроки";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл 
			КоличествоОприходовать = Выборка.КоличествоОтклонениеИнвентаризации - Выборка.КоличествоОприходованное;
			
			Если КоличествоОприходовать <= 0 Тогда
				Продолжить;
			КонецЕсли; 
			
			НовСтрока = Топливо.Добавить();
			НовСтрока.ТС         = Выборка.ТС;
			НовСтрока.ГСМ        = Выборка.ГСМ;
			НовСтрока.Количество = КоличествоОприходовать;
			НовСтрока.Сумма      = Окр(Выборка.Цена * КоличествоОприходовать, 2, РежимОкругления.Окр15как20);
		КонецЦикла;
		
		Если Топливо.Количество() = 0 Тогда
			ТекстНСТР = НСтр("en='In document ""%1"" there are no vehicles with fuels, actual number of which exceeds accounting one.';ru='В документе ""%1"" отсутствуют ТС с ГСМ, фактическое количество которого превышает учетное.'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ДанныеЗаполнения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР,, "Объект");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	МассивТС = Новый Массив();
	Для Каждого ТекСтрока Из Топливо Цикл 
		Если МассивТС.Найти(ТекСтрока.ТС) = Неопределено Тогда 
			МассивТС.Добавить(ТекСтрока.ТС);
		КонецЕсли;
	КонецЦикла;
	
	СписокТС = "";
	Для Каждого ТекТС Из МассивТС Цикл 
		СписокТС = СписокТС + ?(СписокТС = "", "", ", ") + ТекТС.Наименование;
	КонецЦикла;
КонецПроцедуры


#КонецОбласти

#КонецЕсли
