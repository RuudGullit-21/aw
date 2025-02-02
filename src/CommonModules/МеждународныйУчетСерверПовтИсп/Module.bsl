////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции подсистемы "Международный финансовый учет".
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает параметры регистра для отражения в международном учете.
//
// Параметры:
//	ИмяРегистра - Строка - имя регистра, для которого возвращаются параметры отражения.
//
// Возвращаемое значение:
//	Структура - Структура возвращаемых параметров.
//
Функция ПараметрыРегистра(ИмяРегистра) Экспорт

	ПараметрыОтражения = Новый Структура();
	ПараметрыОтражения.Вставить("Показатели", МеждународныйУчетСерверПовтИсп.Показатели(ИмяРегистра));
	ПараметрыОтражения.Вставить("ПоказателиВВалюте", МеждународныйУчетСерверПовтИсп.ПоказателиВВалюте(ИмяРегистра));
	ПараметрыОтражения.Вставить("ИсточникиУточненияСчета", МеждународныйУчетСерверПовтИсп.ИсточникиУточненияСчета(ИмяРегистра));
	ПараметрыОтражения.Вставить("ИсточникиПодразделений", МеждународныйУчетСерверПовтИсп.ИсточникиПодразделений(ИмяРегистра));
	ПараметрыОтражения.Вставить("ИсточникиСубконто", МеждународныйУчетСерверПовтИсп.ИсточникиСубконто(ИмяРегистра));
	
	Возврат ПараметрыОтражения;

КонецФункции

// Определяет источники уточнения счета, доступные в регистре и их свойства.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра.
//
// Возвращаемое значение:
//  Соответствие - Ключ - название источника уточнения счета. 
//				   Значение - структура свойств источника уточнения счета.
//
Функция ИсточникиУточненияСчета(ИмяРегистра) Экспорт

	Если ПустаяСтрока(ИмяРегистра) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СвойстваИсточника = СвойстваИсточникаУточненияСчета();
	ИсточникиУточненияСчета = РегистрыНакопления[ИмяРегистра].ИсточникиУточненияСчета(СвойстваИсточника);
	
	Возврат ИсточникиУточненияСчета;

КонецФункции

// Определяет источники подразделений регистра и их свойства.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя источника. 
//				   Значение - структура свойств источника. 
//
Функция ИсточникиПодразделений(ИмяРегистра) Экспорт

	Если ПустаяСтрока(ИмяРегистра) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИсточникиПодразделений = РегистрыНакопления[ИмяРегистра].ИсточникиПодразделений();
	
	Возврат ИсточникиПодразделений;

КонецФункции

// Определяет источники заполнения субконто.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра.
//
// Возвращаемое значение:
//  Массив - массив атрибутов регистра.
//
Функция ИсточникиСубконто(ИмяРегистра) Экспорт

	Если ПустаяСтрока(ИмяРегистра) Тогда
		Возврат Неопределено;
	КонецЕсли;

	ИсточникиСубконто = РегистрыНакопления[ИмяРегистра].ИсточникиСубконто();
	
	Возврат ИсточникиСубконто;

КонецФункции

// Определяет показатели регистра.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//                 Значение - структура свойств показателя.
//
Функция Показатели(ИмяРегистра) Экспорт

	Если ПустаяСтрока(ИмяРегистра) Тогда
		Возврат Неопределено;
	КонецЕсли;

	СвойстваПоказателей = СвойстваПоказателей();
	Показатели = РегистрыНакопления[ИмяРегистра].Показатели(СвойстваПоказателей);
	
	Возврат Показатели;

КонецФункции

// Определяет показатели в валюте регистра.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//				   Значение - структура свойств показателя.
//
Функция ПоказателиВВалюте(ИмяРегистра) Экспорт

	Если ПустаяСтрока(ИмяРегистра) Тогда
		Возврат Неопределено;
	КонецЕсли;

	СвойстваПоказателей = СвойстваПоказателейВВалюте();
	ПоказателиВВалюте = РегистрыНакопления[ИмяРегистра].ПоказателиВВалюте(СвойстваПоказателей);
	
	Возврат ПоказателиВВалюте;

КонецФункции

// Определяет документы отражаемые в международном учете.
//
// Параметры:
//	ИмяРегистра - Строка - имя регистра.
//
// Возвращаемое значение:
//	Массив - массив документов к отражению в международном учете.
//
Функция ДокументыКОтражениюВМеждународномУчете(ИмяРегистра) Экспорт

	Если ПустаяСтрока(ИмяРегистра) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДокументыКОтражению = РегистрыНакопления[ИмяРегистра].ДокументыКОтражениюВМеждународномУчете();
	
	Возврат ДокументыКОтражению;

КонецФункции

// Возвращает описание ошибки.
//
// Параметры:
//	КодОшибки - Строка - код ошибки.
//
// Возвращаемое значение:
//	Строка - описание ошибки.
//
Функция ТекстОшибки(КодОшибки) Экспорт

	КодыОшибок = КодыОшибокОтраженияВМеждународномУчете();
	ТекстОшибки = КодыОшибок.Получить(КодОшибки);
	
	Возврат ТекстОшибки;

КонецФункции

// Возвращает типы атрибута регистра.
//
// Параметры:
//	ИмяРегистра - Строка - имя регистра.
//	ИмяАтрибута - Строка - имя атрибута.
//
// Возвращаемое значение:
//	Массив - массив типов атрибута регистра.
//
Функция ТипыАтрибутаРегистра(ИмяРегистра, ИмяАтрибута) Экспорт

	МассивТипов = Новый Массив;
	Измерение = Метаданные.РегистрыНакопления[ИмяРегистра].Измерения.Найти(ИмяАтрибута);
	Если Измерение <> Неопределено Тогда
		МассивТипов = Измерение.Тип.Типы();
	КонецЕсли;
	
	Реквизит = Метаданные.РегистрыНакопления[ИмяРегистра].Реквизиты.Найти(ИмяАтрибута);
	Если Реквизит <> Неопределено Тогда
		МассивТипов = Реквизит.Тип.Типы();
	КонецЕсли;
	
	Возврат МассивТипов;
	
КонецФункции

// Возвращает статус на основе приоритетов статусов.
// 
// Параметры:
//	ТекущийСтатус - ПеречислениеСсылка.СтатусыОтраженияВМеждународномУчете - текущий статус.
//	НовыйСтатус - ПеречислениеСсылка.СтатусыОтраженияВМеждународномУчете - текущий статус.
//
//	ПеречислениеСсылка.СтатусыОтраженияВМеждународномУчете - устанавливаемый статус.
//
Функция Статус(ТекущийСтатус, НовыйСтатус) Экспорт

	ПриоритетТекущегоСтатуса = ПриоритетСтатуса(ТекущийСтатус);
	ПриоритетНовогоСтатуса = ПриоритетСтатуса(НовыйСтатус);
	Возврат ?(ПриоритетТекущегоСтатуса = Неопределено ИЛИ ПриоритетНовогоСтатуса < ПриоритетТекущегоСтатуса, НовыйСтатус, ТекущийСтатус);

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СвойстваИсточникаУточненияСчета()

	// Расшифровка свойств источника:
	// ИмяПоля - имя атрибута регистра накопления, из которого планируется получать источник уточнения счета.
	
	Возврат "ИмяПоля";

КонецФункции

Функция СвойстваПоказателей()

	СвойстваПоказателей = Новый Структура("СвойстваПоказателей, СвойстваРесурсов");
	
	// Расшифровка свойств показателей:
	// Ресурсы - массив ресурсов регистра, связанных с показателем.
	СвойстваПоказателей.СвойстваПоказателей = "Ресурсы";
	
	// Расшифровка свойств ресурсов:
	// Имя - имя ресурса регистра.
	// ИсточникВалюты - источник валюты для ресурса регистра.
	СвойстваПоказателей.СвойстваРесурсов = "Имя, ИсточникВалюты";
	
	Возврат СвойстваПоказателей;

КонецФункции

Функция СвойстваПоказателейВВалюте()

	// Расшифровка свойств показателей:
	// ИсточникВалюты - источник валюты для показателя регистра.
	
	Возврат "ИсточникВалюты";

КонецФункции

Функция КодыОшибокОтраженияВМеждународномУчете()

	КодыОшибок = Новый Соответствие;
	КодыОшибок.Вставить("ОтсутствуютШаблоныПроводокДляХозоперации", НСтр("en='There are no posting templates for the business transaction.';ru='Отсутствуют шаблоны проводок для хозяйственной операции.'"));
	КодыОшибок.Вставить("ХозоперацияИгнорируетсяУчетнойПолитикой", НСтр("en='Economic operation is ignored by accounting policies.';ru='Хозяйственная операция игнорируется учетной политикой.'"));
	КодыОшибок.Вставить("НеВыбранИсточникБалансовойСуммы", НСтр("en='Not selected source of the carrying amount.';ru='Не выбран источник балансовой суммы.'"));
	КодыОшибок.Вставить("НеУдалосьЗаполнитьСчетДт", НСтр("en='Failed to fill bill Dt.';ru='Не удалось заполнить счет Дт.'"));
	КодыОшибок.Вставить("НеУдалосьЗаполнитьСчетКт", НСтр("en='Failed to fill bill Cr.';ru='Не удалось заполнить счет Кт.'"));
	КодыОшибок.Вставить("НеВыбранИсточникВалютнойСуммыДт", НСтр("en='Not selected source of currency amount Db.';ru='Не выбран источник валютной суммы Дт.'"));
	КодыОшибок.Вставить("НеВыбранИсточникВалютнойСуммыКт", НСтр("en='Not selected source of currency sum Cr.';ru='Не выбран источник валютной суммы Кт.'"));
	КодыОшибок.Вставить("СуммаПроводкиРавнаНулю", НСтр("en='The value of the source of the balance amount ""%ИсточникСуммы%"" is 0';ru='Значение источника балансовой суммы ""%ИсточникСуммы%"" равно 0'"));
	КодыОшибок.Вставить("НеУдалосьЗаполнитьСубконто", НСтр("en='Failed to fill subkonto %ВидСубконто% of account %Счет%';ru='Не удалось заполнить субконто %ВидСубконто% для счета %Счет%'"));
	
	Возврат КодыОшибок;

КонецФункции

Функция ПриоритетСтатуса(Статус)

	Возврат ПриоритетыСтатусов().Получить(Статус);

КонецФункции

Функция ПриоритетыСтатусов()

	ПриоритетыСтатусов = Новый Соответствие;
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.ИгнорируетсяУчетнойПолитикой, 1);
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.ОтсутствуютПравилаОтраженияВУчете, 2);
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.ОтраженоВУчете, 3);
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.ОтраженоВУчетеВручную, 4);
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.НеОтраженоВУчете, 5);
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.КОтражениюВУчете, 6);
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.КОтражениюВУчетеВручную, 7);
	
	Возврат ПриоритетыСтатусов;

КонецФункции

#КонецОбласти
